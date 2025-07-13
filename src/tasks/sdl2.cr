@[Barista::BelongsTo(Hokusai::OS::Builder)]
class Hokusai::OS::Tasks::SDL2 < Barista::Task
  include_behavior Omnibus

  nametag "sdl2"

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path)

    mkdir("build", parents: true)
    command("../configure --prefix=#{install_dir}/embedded", env: env, chdir: "#{source_dir}/build")
    command("make install", env: env, chdir: "#{source_dir}/build")
  end

  def configure : Nil
    version("2.32.8")
    license("zlib")
    license_file("LICENSE.txt")
    source("https://github.com/libsdl-org/SDL/archive/refs/tags/release-#{version}.tar.gz")
  end
end
