if ARGV.size != 1 then  # check num of commandline args
  puts "Usage: $ ruby #{$0} txtfname" # print usage
  exit
end

caption = ""
option = ""
space = "    "

file_header = "\\documentclass{jsarticle}\n\\begin{document}"
file_footer = "\\end{document}"
table_body = []

File.open(ARGV[0]) do |csvf|
  csvf.each_line do |line|
    line.chomp!
    if line == "" then
      next
    elsif line.index("pdf") != nil then
      pdf = true
    elsif line.index("caption") != nil then
      caption = line.split[1]
    elsif line.index("option") != nil then
      option = line.split[1]
    elsif line == "\\hline" then
      table_body.push(space + line)
    else
      converted_line = space + line.gsub(",", " & ")  # "foo,bar" => "  foo && bar"
      if converted_line.index("\\hline") == nil then
        converted_line << " \\\\"
      else
        converted_line.gsub!("\\hline", "\\\\\\ \\hline")
      end
      table_body.push(converted_line) 
    end
  end
end
table_header1 = "\\begin{table}[htb]\n  \\begin{center}"
table_header2 = "  \\begin{tabular}{#{option}}"
table_footer = "  \\end{tabular}\n  \\end{center}\n\\end{table}"

puts file_header
puts
puts table_header1
if caption != "" then
  puts "  \\caption{#{caption}}"
end
puts table_header2
table_body.each do |line|
  puts line
end
puts table_footer
puts
puts file_footer