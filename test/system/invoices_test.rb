require "application_system_test_case"

class InvoicesTest < ApplicationSystemTestCase
  setup do
    @invoice = invoices(:one)
  end

  test "visiting the index" do
    visit invoices_url
    assert_selector "h1", text: "Invoices"
  end

  test "creating a Invoice" do
    visit invoices_url
    click_on "New Invoice"

    fill_in "Account", with: @invoice.account_id
    fill_in "Plan amount", with: @invoice.plan_amount
    fill_in "Subscription", with: @invoice.subscription_id
    fill_in "Tax amount", with: @invoice.tax_amount
    fill_in "Tax percent", with: @invoice.tax_percent
    fill_in "Total amount", with: @invoice.total_amount
    click_on "Create Invoice"

    assert_text "Invoice was successfully created"
    click_on "Back"
  end

  test "updating a Invoice" do
    visit invoices_url
    click_on "Edit", match: :first

    fill_in "Account", with: @invoice.account_id
    fill_in "Plan amount", with: @invoice.plan_amount
    fill_in "Subscription", with: @invoice.subscription_id
    fill_in "Tax amount", with: @invoice.tax_amount
    fill_in "Tax percent", with: @invoice.tax_percent
    fill_in "Total amount", with: @invoice.total_amount
    click_on "Update Invoice"

    assert_text "Invoice was successfully updated"
    click_on "Back"
  end

  test "destroying a Invoice" do
    visit invoices_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Invoice was successfully destroyed"
  end
end
