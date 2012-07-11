module WellRested
  class CoreFormatter

    def encode(obj)
      obj.to_json
    end

    def decode(serialized_representation)
      result = JSON.parse(serialized_representation)
      # 20120628 CR - Core returns the collection results in an array "items" => find_many()
      # If that doesn't exist, it is a single element, which can be returned as is =>  find()
      return result["items"] || result
    end

  end
end
