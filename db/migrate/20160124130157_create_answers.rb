class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :user_id
      t.integer :question_id
      t.string :content
      t.integer :votes

      t.timestamps null: false
    end
  end
end
