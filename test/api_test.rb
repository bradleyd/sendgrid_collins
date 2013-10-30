require_relative "test_helper"


class SendgridCollins::ApiTest < MiniTest::Test
  def setup
    @api = SendgridCollins.configure do |config|
            config.host     = 'http://foobar.com'
            config.username = 'foo'
            config.password = 'baz'
          end
  end

  def test_im_api_responds_to_new
    assert_respond_to(SendgridCollins::Api, :new)
  end

  def test_api_responds_to_provision_asset
    assert_respond_to(@api, :provision_asset)
  end

  def test_api_responds_to_new_host
    assert_respond_to(@api, :create_asset)
  end

  def test_im_api_responds_to_get_host
    assert_respond_to(@api, :get_asset)
  end

  def test_im_api_responds_to_asset_tag
    assert_respond_to(@api, :asset_tag)
  end

  def test_im_api_responds_to_set_host_attribute
    assert_respond_to(@api, :set_asset_attribute)
  end

  def test_im_api_responds_to_set_host_status
    assert_respond_to(@api, :set_asset_status)
  end

  def test_im_api_responds_to_delete_host_attribute
    assert_respond_to(@api, :delete_asset_attribute)
  end

  def test_im_api_responds_to_delete_host_ipaddress
    assert_respond_to(@api, :delete_asset_ipaddress)
  end

  def test_im_api_responds_to_delete_host
    assert_respond_to(@api, :delete_asset)
  end

  def test_im_api_responds_to_get_address_pools
    assert_respond_to(@api, :ipaddress_pools)

  end

end
