require 'valuable'

require 'acromine/longform_variant'

class Acromine
  # a summary of the long form of an acronym
  class Longform < Valuable
    # @!attribute [rw] longform
    #   @return [String] the long form of the acronym
    has_value :longform

    # @!attribute [rw] frequency
    #   @return [Fixnum] how often the long form has been seen
    has_value :frequency, klass: :integer

    # @!attribute [rw] since
    #   @return [Fixnum] the earliest year the longform was seen
    has_value :since, klass: :integer

    # @!attribute [rw] variants
    #   @return [Array<Acromine::LongformVariant>] variants of the long form
    has_collection :variants, klass: Acromine::LongformVariant
  end
end
