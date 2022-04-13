# Crunsh 0.2
# Takes a set of parameter names and values each parameter can take. Creates 
# for each combination of parameter values a directory and a shell script 
# which calls the program with the appropriate command line arguments.

require 'multArr'
require 'fileutils'

class CrunshCombi
	attr_reader :name, :value, :key

	def initialize(name, value, key = nil)
		if name.class != Array
			@name = [name]
			@value = [value]
		else
			@name = name
			@value = value
		end

		@key = key ? key : @value

		if @key.class != Array
			@key = [@key]
		end
	end

	def to_s
		@key.join("-")
	end

	def to_arg(prefix, sep = " ")
		ret = ""
		@name.each_index do |p|
			ret += prefix + @name[p].to_s + sep 
            if @value[p].class == Array 
                ret += @value[p].collect{|e| '"' + e.to_s + '"'}.join(" ")
            else
                ret += '"' + @value[p].to_s  + '"'
            end
            ret += " "
		end
		ret
	end
end

class Crunsh
	include FileUtils

	def initialize(progName, cmdsFileName: "commands", dirPrefix: "x", 
				   argPrefix: "--", argSep: " ", mode: "create", &block)
		@progName = progName
		@cmdsFileName = cmdsFileName
		@argPrefix = argPrefix
		@argSep = argSep
		@dirPrefix = dirPrefix
		@params = []
		@preset = []
		@par_list = []

		if (block != nil)
			instance_eval(&block)
			if mode == "create"
				create
			elsif mode == "dryrun"
				dryrun
			elsif mode == "parameters"
				parameters
			end
		end
	end

	def set(name, value)
		@preset << CrunshCombi.new(name, value)
		self
	end

	def par(name, *values)
		tvalues = nil

		# [name1, ...], {tag1 => [v1, ...], ...}	
		if name.class == Array && values[0].class == Hash
			# p values
			tvalues = values[0].collect {|k, v| CrunshCombi.new(name, v, k)}
			@par_list << (values.size == 2 ? values[1] : values[0].keys[0])
		# name, v1, ...
		else
			tvalues = values.collect {|v| CrunshCombi.new(name, v)}
			@par_list << name
		end

		@params = @params.mult(tvalues)

		self
	end

	def onCreate(&block)
		@onCreate = block
		self
	end

	def runs
		@params.map do |par|
            if par.class != Array
                par = [par]
            end

            par.flatten!

			args = @preset.map { |p| p.to_arg(@argPrefix, @argSep) }
			args << par.map { |p| p.to_arg(@argPrefix, @argSep) }

			[par, args]
		end
	end

	def dirname(run)
		@dirPrefix + run[0].join("_").delete("/")
	end

	def cmdl(run)
		@progName.gsub("%ARGS%", run[1].join(" "))
	end

	def create
		commands = File.new(@cmdsFileName, "w")

		runs.each do |r|
			dir = dirname(r)

			commands.puts(dir)
			commands.puts("sh run")
			mkdir dir
			cd dir

			File.new("run", "w").puts "#!/bin/bash\n" + cmdl(r)

			if @onCreate
				@onCreate.call(r[0], r[1], dir)
			end

			cd ".."
		end
	end

	def dryrun
		runs.each do |r|
			puts("creating ", dirname(r))
			puts("calling ", cmdl(r))
			if @onCreate
				puts("onCreate(", r[0], ", ", r[1], ", ", dirname(r), ")")
			end
		end
	end


	def parameters
		puts @par_list.join("\t")
	end

end

