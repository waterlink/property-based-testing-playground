require 'rantly'
require 'rantly/shrinks'
require 'rantly/rspec'

describe 'Rspec + rantly' do
  it 'tuple doc is valid' do
    property_of {
      Tuple.new( array(range(0, 10)) { integer } )
    }.check { |t|
      expect(t.size).to be <= 10
    }
  end

  it 'deflating doc is valid' do
    property_of {
      Deflating.new( array(range(0, 10)) { integer } )
    }.check { |t|
      expect(t.size).to be <= 10
    }
  end
end
