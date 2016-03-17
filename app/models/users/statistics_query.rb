module Users
  class StatisticsQuery
    class << self
      delegate :call, to: :new
    end

    attr_reader :relation

    def initialize(relation = User.all)
      @relation = relation
    end

    def user_table
      User.arel_table
    end

    def questions_table
      Question.arel_table
    end

    def answers_table
      Answer.arel_table
    end

    def join_associations
      user_table.outer_join(questions_table).on(user_table[:id].eq(questions_table[:user_id])).
      outer_join(answers_table).on(user_table[:id].eq(answers_table[:user_id])).join_sources
    end

    def questions_asked
      questions_table.project(Arel.star.count).where(questions_table[:user_id].eq(user_table[:id])).as("questions_asked")
    end

    def answers_given
      answers_table.project(Arel.star.count).where(answers_table[:user_id].eq(user_table[:id])).as("answers_given")
    end

    def user_data
      user_table[Arel.star]
    end

    def group_associations
      user_table.group(user_table[:id])
    end

    def call
      relation.joins(join_associations).select(user_data, questions_asked, answers_given).group("users.id")
    end
  end
end
