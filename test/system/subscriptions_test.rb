require "application_system_test_case"

class SubscriptionsTest < ApplicationSystemTestCase
  setup do
    @subscription = subscriptions(:one)
  end

  test "visiting the index" do
    visit subscriptions_url
    assert_selector "h1", text: "Subscriptions"
  end

  test "creating a Subscription" do
    visit subscriptions_url
    click_on "New Subscription"

    fill_in "Account", with: @subscription.account_id
    fill_in "Amount", with: @subscription.amount
    fill_in "Card country", with: @subscription.card_country
    fill_in "Ip address", with: @subscription.ip_address
    fill_in "Ip country", with: @subscription.ip_country
    fill_in "Latest paid date", with: @subscription.latest_paid_date
    fill_in "Residence country", with: @subscription.residence_country
    click_on "Create Subscription"

    assert_text "Subscription was successfully created"
    click_on "Back"
  end

  test "updating a Subscription" do
    visit subscriptions_url
    click_on "Edit", match: :first

    fill_in "Account", with: @subscription.account_id
    fill_in "Amount", with: @subscription.amount
    fill_in "Card country", with: @subscription.card_country
    fill_in "Ip address", with: @subscription.ip_address
    fill_in "Ip country", with: @subscription.ip_country
    fill_in "Latest paid date", with: @subscription.latest_paid_date
    fill_in "Residence country", with: @subscription.residence_country
    click_on "Update Subscription"

    assert_text "Subscription was successfully updated"
    click_on "Back"
  end

  test "destroying a Subscription" do
    visit subscriptions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Subscription was successfully destroyed"
  end
end
