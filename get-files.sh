find ./ -type f -name "*\.wiff2" -printf "%f\n" | sort > ../midas-data-files.txt

split -l 300 --additional-suffix=-midas.txt ../midas-data-files.txt
