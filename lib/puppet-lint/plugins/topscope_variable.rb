PuppetLint.new_check(:topscope_variable) do
  def check
    class_list = (class_indexes + defined_type_indexes)
    # do not check if the code is not part of a class
    return if class_list.first.nil?
    class_name = class_list.first[:name_token].value.split('::').first
    tokens.select { |x| x.type == :VARIABLE }.each do |token|
      next if token.value !~ /^::#{class_name}::/
      fixed = token.value.sub(/^::/, '')
      notify(
        :warning,
        message: "use $#{fixed} instead of $#{token.value}",
        line: token.line,
        column: token.column,
        token: token
      )
    end
  end

  def fix(problem)
    problem[:token].value.sub!(/^::/, '')
  end
end
