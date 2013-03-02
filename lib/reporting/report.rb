module Reporting
  # Class for representing chart data needed for Google Visualisation
  class Report
    def initialize
      @columns = []
      @rows = []
    end

    def add_column(label, type = 'string', id = nil)
      id ||= @columns.size

      @columns << Column.new(id, label, type)

      return self
    end

    def add_row(cells)
      if cells.size != @columns.size
        raise "Incorect number of columns specified"
      end

      @rows << Row.new(cells)

      return self
    end

    def to_json
      return {cols: @columns, rows: @rows}.to_json
    end
  end

  private  
  class Column
    def initialize(id, label = nil, type = 'string')
      @id = id
      @label = label
      @type = type
    end
  end

  class Row
    def initialize(cells)
      @cells = []

      cells.each do |cell_value|
      	add_cell(cell_value)
      end
    end

    def add_cell(value, formated_value=nil)
    	@cells << Cell.new(value, formated_value)
    	return self    	
    end

    def add_cells(cells)
      @cells << cells
      return self
    end

    def as_json(options = {})
    	return {c: @cells}
    end
  end

  class Cell
    def initialize(value, formated_value = nil)
      @value = value
      @formated_value = formated_value
    end

    def as_json(options = {})
    	return {v: @value, f: @formated_value}
    end
  end
end