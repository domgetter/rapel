require 'spec_helper'

describe Rapel::Expression do
  it "can be evaluated in a context" do
    context = double
    allow(context).to receive(:session_id)
    expect{Rapel::Expression.new("2").evaluate(context, &-> result {})}.to_not raise_error
  end
end
