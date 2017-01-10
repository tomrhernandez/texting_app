class MessageSearch
    
    attr_reader :date_from, :date_to
    
    def initialize(params)
        params ||= {}
        @date_from = parsed_date(params[:date_from], 30.days.ago.to_date.to_s)
        @date_to = parsed_date(params[:date_to], Date.tomorrow.to_s)
    end
    
    def scope
        Message.where('created_at BETWEEN ? AND ?', @date_from, @date_to)
    end
    
    private
    
    def string_formatter(date)
        month = date.slice(0..1)
        day = date.slice(2..3)
        year = date.slice(4..7)
        return "#{year}-#{month}-#{day}"
    end

    
    def parsed_date(date_string, default)
        if date_string.length == 8
            string_formatter(date_string)
        else
        Date.parse(date_string)
        end
    rescue ArgumentError, TypeError, NoMethodError
        default
    end
    
end