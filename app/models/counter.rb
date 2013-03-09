class Counter
  include Mongoid::Document

  field :seq, type: Integer
  field :_id, type: String, default: ->{ "userid" }
end