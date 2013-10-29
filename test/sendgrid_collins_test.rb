require_relative "test_helper"


class SendgridCollinsTest < Minitest::Test
  def setup
  
  end

  def test_responds_to_configure
    assert_respond_to SendgridCollins, :configure
  end

  def test_pass_configure_a_block
    sgc = SendgridCollins.configure do |option|
            option.username = 'collins'
            option.password = 'collins'
            option.host     = 'http://collins.sendgrid.net:8080'
          end
    assert sgc 
  end
end
