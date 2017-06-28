#master file
#calls the functions from the others

Dir["./*.rb"].each { |file| require file }

#checks for the directory "patientfiles" then makes one if it doesn't exist
if File.directory?("patientfiles") == false
  Dir.new "patientfiles"
  puts "made new dir"
end

#makes the neccessary objects
donorcounter = Donors.new
filewriter = Writer.new
mutationsorter = Sorter.new
#puts filewriter.donornumber
puts "starting to work"

filenames = []

#im using a test file with only 50,000 lines intead of 12 million. the
#original file is -- simple_somatic_mutation.open.BRCA-EU.vcf -- . this is
#just for convinence.
datafile = "tests/smalldata.txt"


#
#loops through each donor and then puts each line of data that includes
#the id of the donor into a file labeled by the id

#the files are located in patientfiles/~filename~
donorcounter.count(datafile)
donorcounter.donors.each do |donor|
  filewriter.openDonorFile(donor)
  filenames << "patientfiles/donor#{donor}.txt"

  puts "going to sort through the data"
  #goes through the data 10,000 lines at a time to avoid crashing the ram
  File.open(datafile).each_slice(10000){|l1000|
    #print l1000
    filewriter.write_mutations(l1000)
  }
  puts 'finished sorting'
  filewriter.closeDonorFile
end

#sorts through the patientfiles individually and sorts them, first
#by chromosome, then by spacing.
filenames.each do |name|
  mutationsorter.open_file(name)
  mutationsorter.sort_by_chr

  mutationsorter.close_file
end


#the end
puts "stopping now"
exit
