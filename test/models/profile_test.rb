# == Schema Information
#
# Table name: profiles
#
#  id                :integer          not null, primary key
#  document_type     :string
#  document_url      :string
#  full_name         :string
#  nationality       :string
#  birth_date        :date
#  profile_image_url :string
#  bio               :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
