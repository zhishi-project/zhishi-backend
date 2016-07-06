class Dummy
  def self.create_with_methods(methods_hash)
    methods_hash.each do |name, return_val|
      define_method "#{name}" do
        return_val
      end
    end
    new
  end
end
