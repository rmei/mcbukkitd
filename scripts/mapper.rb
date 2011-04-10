#!/usr/bin/ruby

require "yaml"
require "shell"

ess_cfg="plugins/Essentials"
grp_cfg="plugins/EssentialsGroupManager"
world="boxlandia"
f = {
    :spawn => "#{ess_cfg}/spawn.yml",
    :essconfig => "#{ess_cfg}/config.yml",
}


#spawn = YAML.load_file( f[:spawn] )
$DEF_EX = {
    :mcmap => '/usr/local/bin/mcmap',
    :rsync => '/usr/bin/rsync',
    :pngcrunch => '/usr/local/bin/pngcrunch',
}

def do_(command, *args)
    x=['[', command] << args << ']'
    puts x.join ", "
    #system command, *args
end

class Mapper
    def initialize(mcdir, world, nether='nether', imgdir='/var/www/html', history='history', ex=$DEF_EX)
        @mcdir, @world, @nether, @imgdir, @history, @ex = mcdir, world, nether, imgdir, history, ex
        @users = []
        @dirs = {}
        @dirs[:plugins] = File.join @mcdir, 'plugins'
        @dirs[:ess] = File.join @dirs[:plugins], 'Essentials'
        @dirs[:userdata] = File.join @dirs[:ess], 'userdata'
        @dirs[:warps] = File.join @dirs[:ess], 'warps'
    end

    def get_users
        files=Dir.entries(@dirs[:userdata]).reject {|f| f.start_with? "."}
        @users << ( files.map {|f| { f.sub(".yml", "").to_sym => YAML.load_file(File.join @dirs[:userdata], f) } } )
        
    end
    def makemap(path=@mcdir + "/" + @world, from=nil, to=nil, *labels) 
        args=[path]
        args << '-from' << from[0..1] if from
        args << '-to' << to[0..1] if to
        do_ @ex[:mcmap], *args
    end
end

mapper = Mapper.new(ENV['HOME'] + "/mc.tmp", "boxlandia")


$,,$\=", ","\n"
mapper.makemap 'boxlandia', [-10, -20], [30, 40]
u= mapper.get_users
print u[1]



#mapper.makemap "boxlandia", [-10, -10], [10, 10]

# collect context:
#   where is mc?
#   where are the plugins?
#   which worlddir? is there a nether?
#   where do images go?  is there a history dir?
#   where are the tools (mcmap, rsync? others?)
# method for executing mcmap
#   takes worlddir, region dimensions, labels
# methods for particular image types:
#   full map (overland, nether) (maybe annotated)
#   warp map?
#   user-environs (aboveground, caves)
# method for running pngcrush
# method for generating thumbnails?
# method for generating index pages?  How do thumbnails work?
#
# process
#   identify users
#   generate per-user maps
#   generate full map
#   post-process maps.

