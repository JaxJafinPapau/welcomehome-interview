class RentRollService
  def initialize(date)
    @date = date
  end

  def execute_query
  sql = <<~SQL
      SELECT
        u.number     AS unit_number,
        u.floor_plan AS floor_plan,
        r.name       AS resident_name,
        o.move_in    AS move_in,
        o.move_out   AS move_out,
        CASE
          WHEN o.id IS NULL THEN NULL
          WHEN o.move_in <= :date THEN 'current'
          ELSE 'future'
        END AS status
      FROM units u
      LEFT JOIN occupancies o
        ON o.unit_id = u.id
      AND (o.move_out IS NULL OR o.move_out >= :date)
      LEFT JOIN residents r ON r.id = o.resident_id
      ORDER BY u.number, o.move_in NULLS LAST
    SQL

    ActiveRecord::Base.connection
    .exec_query(ActiveRecord::Base.sanitize_sql_array([sql, date: @date]))
  end
end