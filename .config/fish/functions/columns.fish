function columns
  argparse 'debug' 'headless' 'd/column_delimiter=?' 'f/line_filter=?' 'c/wanted_column=+' -- $argv || return $status

  if isatty
    set table $argv
  else
    while read -l line
      set -a table $line
    end
  end

  if blank $table
    return 1
  end

  if blank $_flag_column_delimiter
    set _flag_column_delimiter '\s'
  end

  set columns
  set starting_indexes
  set line_index 0

  if present $_flag_debug
    echo table size: (count $table)
    echo
    echo parsed argv:
    echo -e "\tcolumn_delimiter: $_flag_column_delimiter"
    echo -e "\tline_filter:      $_flag_line_filter"
    echo -e "\twanted_column:    $_flag_wanted_column"
    echo -e "\theadless:         $_flag_headless"
    echo
    echo padding starting_indexes:
  end

  for line in $table
    set index 0
    set column 0
    set last_empty 1
    set updated 0
    set line_index (math $line_index + 1)

    for char in (string split '' $line)
      set index (math 1 + $index)
      if test $last_empty -eq 1 && string match -q -v -r $_flag_column_delimiter $char
        set column (math $column + 1)
        set last_empty 0
        if blank $starting_indexes[$column] || test $index -lt $starting_indexes[$column]
          if blank $columns || test $column -le $columns
            set starting_indexes[$column] $index
            set updated 1
          end
        end
      else if string match -q -r $_flag_column_delimiter $char
        set last_empty 1
      end
    end

    if blank $columns
      set columns (count $starting_indexes)
    end

    if present $_flag_debug && test $updated -eq 1
      echo -e \t"$line_index:"\t"$starting_indexes"\t - \'$line\'
    end
  end

  if present $_flag_debug
    echo
    echo padded starting_indexes:
    for starting_index in $starting_indexes
      echo \t\'(string sub -s $starting_index -l 1 $table[1])\' $starting_index
    end
    echo
    echo columns: $columns
    echo
  end

  if present $_flag_headless
    set override 0
  else
    set override 1
  end

  set matched 0

  for line in $table
    if test $override -eq 1 || blank $_flag_line_filter || string match -q -r $_flag_line_filter $line
      set matched (math $matched + 1)
      set override 0

      for column in (seq $columns)
        set starting_index $starting_indexes[$column]
        set ending_index $starting_indexes[(math $column + 1)]
        if blank $_flag_wanted_column || contains -- $column $_flag_wanted_column
          if present $_flag_debug
            echo -n [$column]
          end

          if present $ending_index
            echo -n (string sub -s $starting_index -e (math $ending_index - 1) $line)
          else
            echo -n (string sub -s $starting_index $line)
          end
        end
      end
      echo

      if present $_flag_debug && test $matched -eq 5
        echo "...breaking the output"
        break
      end
    end
  end
end
