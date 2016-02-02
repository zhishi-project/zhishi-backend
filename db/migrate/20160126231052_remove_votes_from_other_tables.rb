class RemoveVotesFromOtherTables < ActiveRecord::Migration
  def change
    remove_column :questions, :votes, :integer
    remove_column :answers, :votes, :integer
    remove_column :comments, :votes, :integer
  end
end
