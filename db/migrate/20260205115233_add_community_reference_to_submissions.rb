class AddCommunityReferenceToSubmissions < ActiveRecord::Migration[8.1]
  def change
    add_reference :submissions, :community, null: false, foreign_key: true
  end
end
