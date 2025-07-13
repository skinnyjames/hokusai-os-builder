# @[Barista::BelongsTo(Hokusai::OS::Builder)]
# class Hokusai::OS::Tasks::TruffleRuby < Barista::Task
#   include_behavior Omnibus

#   nametag "ruby"

#   dependency Graalvm

#   def build : Nil
#     env = with_javahome(with_standard_compiler_flags(with_embedded_path))
#     mkdir("#{smart_install_dir}/embedded/truffleruby", parents: true)
#     sync(source_dir, "#{smart_install_dir}/embedded/truffleruby")

#     # command("#{smart_install_dir}/embedded/truffleruby/lib/truffle/post_install_hook.sh", env: env)
    
#     # command("#{gem} install hokusai-zero -v 0.2.6.pre.android", env: env)
#   end

#   def gem
#     "#{smart_install_dir}/embedded/truffleruby/bin/gem"
#   end

#   def with_javahome(env)
#     {
#       "JAVA_HOME" => "#{install_dir}/embedded/graalvm",
#       "GRAALVM_HOME" => "#{install_dir}/embedded/graalvm"
#     }.merge(env)
#   end

#   def configure : Nil
#     architecture = kernel.machine == "aarch64" ? "aarch64" : "amd64"
#     os = macos? ? "macos" : "linux"

#     version("24.2.1")
#     source("https://github.com/oracle/truffleruby/releases/download/graal-#{version}/truffleruby-community-#{version}-#{os}-#{architecture}.tar.gz")
#     license("TruffleRuby")
#     license_file("LICENSE_TRUFFLERUBY.txt")
#   end
# end