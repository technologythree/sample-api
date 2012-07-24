# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    title "MyString"
    content "MyString"
    published_on "2012-07-24 01:45:58"
  end
  factory :invalid_page, class: Page do
    title nil
    content nil
    published_on nil
  end
end