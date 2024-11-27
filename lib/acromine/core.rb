require 'httparty'

require 'acromine/longform'
require 'acromine/longform_variant'

# a client for the Acromine REST service
class Acromine
  include HTTParty

  # the URL to the Acromine REST service
  DEFAULT_URI = 'http://www.nactem.ac.uk/software/acromine/dictionary.py'

  # constructs an Acromine object
  # @param uri [String] the URI to the Acromine REST service
  def initialize(uri = DEFAULT_URI)
    self.class.base_uri uri
    self.class.format :json
  end

  # finds the long form(s) of an acronym
  # @param acronym [String] the acronym to expand
  # @param opts [Hash] sort and limit options
  # @return [Array<Acromine::Longform>, []] a list of long forms for the
  #   acronym, or an empty array if the acronym was not found
  def longforms(acronym, opts = {})
    # validate our options
    validate_opts(**opts)
    # get the acronyms from the webservice
    ret = self.class.get('', query: { sf: acronym })
    # an empty JSON array means the acronym was not found
    return [] if ret.body == "[]\n"
    build_lfs(ret, opts)
  end

  private

  # validates filter and sort options
  # @param limit [Fixnum] how many long forms to return
  # @param sort_spec [String] how to sort the long forms on frequency and year
  # @raise RuntimeError if parameters are invalid
  def validate_opts(limit: nil, sort_spec: nil)
    # validate that the limit is a positive integer
    if limit
      begin
        !Float(limit).nil?
      rescue
        raise "invalid limit '#{limit}'"
      end
      fail "invalid limit '#{limit}'" if limit.to_i < 1
    end
    # validate the sort spec(s)
    return unless sort_spec
    specs = sort_spec.split(/,/)
    fail 'too many sort specs (max 2)' if specs.size > 2
    specs.each do|spec|
      fail "invalid sort spec '#{sort_spec}'" unless spec.match(/^[fy][ad]$/)
    end
  end

  # builds LongForm objects from the JSON returned by the REST service
  # @param json [Array] a list of long forms as described by
  #   http://www.nactem.ac.uk/software/acromine/rest.html
  # @param opts [Hash] sort and limit options
  # @return [Array<Acromine::Longform>] a list of long form objects
  # @api private
  def build_lfs(json, opts = {})
    ret = []
    massage_data(json[0]['lfs'], **opts).each do |lf|
      lfobj = build_lf(lf)
      ret << lfobj
    end
    ret
  end

  # sorts and limits the JSON data returned from the REST service
  # @param json [Array] the 'lfs' data from the web service
  # @param limit [Fixnum] how many long forms to return
  # @param sort_spec [String] how to sort on frequency and year
  # @api private
  def massage_data(json, limit: nil, sort_spec: 'fd,ya')
    xforms = build_sort_xforms(sort_spec + ',la')
    sorted = json.sort_by do |e|
      xforms.map { |x| x.call(e) }
    end
    # only return the top x if a limit was specified
    limit.nil? ? sorted : sorted.take(limit.to_i)
  end

  # returns a set of lambdas that will extract the correct transformed
  #   elements of a long form based on a sort spec
  # @param sort_spec [String] how to sort the long forms on frequency
  #   and year.  The spec is one or two two-character pairs joined by
  #   a comma.  The first character of the pair is what to sort - f for
  #   the frequency and y for the year.  The second character of the pair
  #   is how to sort - a for ascending and d for descending
  # @example sort by frequency descending then year ascending
  #   build_sort_xforms('fd,ya')
  # @example sort by year descending then frequency descending
  #   build_sort_xforms('yd,fd')
  # @example sort just by year ascending (i.e. oldest first)
  #   build_sort_xforms('ya')
  # @return [Array<#call>] a set of transforms from longform JSON data
  #   into a sortable tuple
  # @api private
  def build_sort_xforms(sort_spec)
    xforms = []
    sort_spec.split(',').each do |spec|
      what, how = spec.chars
      xforms << case what
                when 'f'
                  case how
                  when 'a'
                    ->(x) { x['freq'] }
                  when 'd'
                    ->(x) { -x['freq'] }
                  end
                when 'y'
                  case how
                  when 'a'
                    ->(x) { x['since'] }
                  when 'd'
                    ->(x) { -x['since'] }
                  end
                when 'l'
                  case how
                  when 'a'
                    ->(x) { x['lf'] }
                  end
                end
    end
    xforms
  end

  # builds a single Acromine::Longform object
  # @param lf [Hash] a single 'lf' entry from the JSON returned by
  #   the webservice
  # @return [Acromine::Longform]
  # @api private
  def build_lf(lf)
    lfobj = Acromine::Longform.new(
      longform: lf['lf'],
      frequency: lf['freq'],
      since: lf['since']
    )
    lf['vars'].each do |var|
      lfobj.variants << build_lfv(var)
    end
    lfobj
  end

  # builds a single Acromine::LongformVariant object
  # @param var [Hash] a single 'lf' variant entry from the JSON returned
  #   by the webservice
  # @return [Acromine::LongformVariant]
  # @api private
  def build_lfv(var)
    Acromine::LongformVariant.new(
      longform: var['lf'],
      frequency: var['freq'],
      since: var['since']
    )
  end
end
