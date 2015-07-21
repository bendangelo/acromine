require 'valuable'

class Acromine
  # a specific variant of a long form of an acronym
  class LongformVariant < Valuable
    # @!attribute [rw] longform
    #   @return [String] the long form of the acronym
    has_value :longform

    # @!attribute [rw] frequency
    #   @return [Fixnum] how often the long form has been seen
    has_value :frequency, klass: :integer

    # @!attribute [rw] since
    #   @return [Fixnum] the earliest year the longform was seen
    has_value :since, klass: :integer
  end
end
