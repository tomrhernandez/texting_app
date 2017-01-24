class MessageSearch
    
    # Let message search params 
    attr_reader :date_from, :date_to
    
    def initialize(params)
        params ||= {}
        @date_from = parsed_date(params[:date_from], 30.days.ago.to_date.to_s)
        @date_to = parsed_date(params[:date_to], Date.tomorrow.to_s)
    end
    
    # Generate SQL date range query.
    def scope
        Message.where('DATE(created_at) BETWEEN ? AND ?', @date_from, @date_to)
    end
    
    private
    
    # Takes MM-DD-YYYY format and converts it to YYYY-MM-DD
    def string_formatter(date)
        month = date.slice(0..1)
        day = date.slice(3..4)
        year = date.slice(6..9)
        return "#{year}-#{month}-#{day}"
    end

    # Turn string object into date object.
    def parsed_date(date_string, default)
        if date_string.length == 10
            string_formatter(date_string)
        else
        Date.parse(date_string)
        end
    rescue ArgumentError, TypeError, NoMethodError
        default
    end
    
end