require_relative '../hashmap'

describe Node do
  before(:each) do
    @test_node = Node.new('node name', 'node value')
  end

  it 'tests initialize in the Node class' do
    expect(@test_node.name).to eq('node name')
  end

  it 'tests the value' do
    expect(@test_node.value).to eq('node value')
  end

  it 'tests the next_node' do
    expect(@test_node.next_node).to be_nil
  end
end

describe Hashmap do
  before(:each) do
    @my_hashmap = described_class.new
  end

  it 'tests #keys' do
    expect(@my_hashmap).to receive(:keys_or_values).with('keys').once
    @my_hashmap.keys
  end

  it 'tests #values' do
    expect(@my_hashmap).to receive(:keys_or_values).with('values').once
    @my_hashmap.values
  end

  it 'tests #entries' do
    expect(@my_hashmap).to receive(:keys_or_values).with('entries').once
    @my_hashmap.entries
  end

  it 'tests #load_factor - makes sure size doubles when 75% full' do
    my_hashmap = described_class.new
    my_hashmap.clear(4)
    my_hashmap.set('test 1', 'value 1')
    my_hashmap.set('test 2', 'value 2')
    expect(my_hashmap.hashmap.length).to eq(4)
    my_hashmap.set('test 3', 'value 3')
    my_hashmap.load_factor
    expect(my_hashmap.hashmap.length).to eq(8)
  end

  context('adding 3 nodes for testing #keys_or_values') do
    before(:each) do
      new_node4 = Node.new('test name 4', 'test value 4')
      new_node6 = Node.new('test name 6', 'test value 6')
      new_node9 = Node.new('test name 9', 'test value 9')
      @my_hashmap.hashmap[4].next_node = new_node4
      @my_hashmap.hashmap[6].next_node = new_node6
      @my_hashmap.hashmap[9].next_node = new_node9
    end

    it 'tests #keys_or_values - name' do
      expect(@my_hashmap.hashmap.length).to eq(16)
      result = @my_hashmap.keys_or_values('keys')
      expect(result).to eq(['test name 4', 'test name 6', 'test name 9'])
    end

    it 'tests #keys_or_values - value' do
      expect(@my_hashmap.hashmap.length).to eq(16)
      result = @my_hashmap.keys_or_values('values')
      expect(result).to eq(['test value 4', 'test value 6', 'test value 9'])
    end

    it 'tests #keys_or_values - entries' do
      expect(@my_hashmap.hashmap.length).to eq(16)
      result = @my_hashmap.keys_or_values('entries')
      expect(result).to eq([['test name 4', 'test value 4'], ['test name 6', 'test value 6'], ['test name 9', 'test value 9']])
    end
  end

  context('adding 3 nodes for testing #clear, #length, #remove') do
    before(:each) do
      new_node4 = Node.new('test name 4', 'test value 4')
      new_node6 = Node.new('test name 6', 'test value 6')
      new_node9 = Node.new('test name 9', 'test value 9')
      @my_hashmap.hashmap[4].next_node = new_node4
      @my_hashmap.hashmap[6].next_node = new_node6
      @my_hashmap.hashmap[9].next_node = new_node9
    end

    it 'tests #clear' do
      expect(@my_hashmap.hashmap.length).to eq(16)
      expect(@my_hashmap.hashmap[4].next_node.name).to eq('test name 4')
      expect(@my_hashmap.hashmap[6].next_node.name).to eq('test name 6')
      expect(@my_hashmap.hashmap[9].next_node.name).to eq('test name 9')
      @my_hashmap.clear
      expect(@my_hashmap.hashmap[4].next_node).to be_nil
      expect(@my_hashmap.hashmap[6].next_node).to be_nil
      expect(@my_hashmap.hashmap[9].next_node).to be_nil
    end

    it 'tests #length' do
      result = @my_hashmap.length
      expect(result).to eq(3)
    end

    it 'tests #remove' do
      expect(@my_hashmap.hashmap[4].next_node.name).to eq('test name 4')
      expect(@my_hashmap.hashmap[6].next_node.name).to eq('test name 6')
      expect(@my_hashmap.hashmap[9].next_node.name).to eq('test name 9')
      expect(@my_hashmap.length).to eq(3)
      @my_hashmap.remove('test name 6')
      expect(@my_hashmap.hashmap[4].next_node.name).to eq('test name 4')
      expect(@my_hashmap.hashmap[6].next_node).to be_nil
      expect(@my_hashmap.hashmap[9].next_node.name).to eq('test name 9')
      expect(@my_hashmap.length).to eq(2)
    end
  end

  context 'adding 3 nodes for testing #key?, #get, #set' do
    before(:each) do
      new_node4 = Node.new('test name 4', 'test value 4')
      new_node6 = Node.new('test name 6', 'test value 6')
      new_node9 = Node.new('test name 9', 'test value 9')
      @my_hashmap.hashmap[4].next_node = new_node4
      @my_hashmap.hashmap[6].next_node = new_node6
      @my_hashmap.hashmap[9].next_node = new_node9
    end

    it 'tests #key' do
      result = @my_hashmap.key?('test name 9')
      expect(result).to be true
      result_fail = @my_hashmap.key?('no key here')
      expect(result_fail).to be false
    end

    it 'tests #get' do
      result1 = @my_hashmap.get('test name 4')
      expect(result1.name).to eq('test name 4')
      result2 = @my_hashmap.get('test name 6', 'child')
      expect(result2.name).to eq('HEAD NODE')
      expect(result2.next_node.name).to eq('test name 6')
    end

    it 'tests #set' do
      expect(@my_hashmap.hashmap[7].next_node).to be_nil
      @my_hashmap.set('This is a new node name!', 'This is a new node value!')
      expect(@my_hashmap.hashmap[7].next_node.name).to eq('This is a new node name!')
    end
  end
end
