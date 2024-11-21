function argparse_regex --argument-names regex desc
    string match -rq "$regex" "$_flag_value"
    if test $status -ne 0
        echo "expected argument $_flag_name to be $desc but found '$_flag_value'"
        return 1
    end
end
