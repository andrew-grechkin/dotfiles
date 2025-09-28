class JSONDump
  DEFAULT_OPTS = {}

  def initialize(opts = DEFAULT_OPTS)
    @opts = opts
  end

  def dump(data)
    JSONDump.dump(data, @opts)
  end

  def self.dump(data, opts = DEFAULT_OPTS)
    cls = data.class
    if cls == Hash
      JSONDump.dump_hash(data, opts)
    elsif cls == Array
      JSONDump.dump_array(data, opts)
    elsif [Float, Integer, TrueClass, FalseClass].include?(cls)
      print data
    elsif cls == NilClass
      print 'null'
    # elsif data.response_to(:to_hash)
    #   JSONDump.dump(data.to_hash, @opts)
    else
      dump_string(data)
    end
  end

  private

  def self.dump_hash(data, opts)
    tail = false
    print '{'
    data.keys.sort.each do |k|
      tail ? print(',') : tail = true
      JSONDump.dump_string(k)
      print ':'
      JSONDump.dump(data[k], opts)
    end
    print '}'
  end

  def self.dump_array(data, opts)
    tail = false
    print '['
    data.each do |it|
      tail ? print(',') : tail = true
      JSONDump.dump(it, opts)
    end
    print ']'
  end

  def self.dump_string(data)
    print data.to_s.inspect
  end
end
