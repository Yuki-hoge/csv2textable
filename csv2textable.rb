# require 'open3'

if ARGV.size != 1 then  # check num of commandline args
  puts "Usage: $ ruby #{$0} txtfname" # print usage
  exit
end

caption = ""
option = ""
space = "    "
pdf = true
outfname = "out"
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
      converted_line = space + line.gsub(",", " & ")  # "foo,bar" => "    foo && bar"
      if converted_line.index("\\hline") == nil then
        converted_line << " \\\\"
      else
        converted_line.gsub!("\\hline", "\\\\\\ \\hline")
      end
      table_body.push(converted_line) 
    end
  end
end
table_header1 = "\\begin{table}[htb]"
table_header2 = "  \\begin{tabular}{#{option}}"
table_footer = "  \\end{tabular}\n\\end{table}"

if pdf then
  # 標準出力の出力先を ./out.tex に変更
  $stdout = File.open(outfname + ".tex", "w")
  puts file_header
  puts
end
puts table_header1
if caption != "" then
  puts "  \\caption{#{caption}}"
end
puts table_header2
table_body.each do |line|
  puts line
end
puts table_footer
if pdf then
  puts
  puts file_footer
  $stdout = STDOUT   # 元に戻す
end

if pdf then
  #Open3.capture3("ptex2pdf", "-l -ot \"-synctex=1 -shell-escape\" #{outfname + ".tex"}")
  # `ptex2pdf -l -ot "-synctex=1 -shell-escape" #{outfname + ".tex"}`
  # system("rm -f #{outfname + ".aux"} #{outfname + ".log"} #{outfname + ".tex"}")
end
