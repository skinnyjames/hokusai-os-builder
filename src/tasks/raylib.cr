@[Barista::BelongsTo(Hokusai::OS::Builder)]
class Hokusai::OS::Tasks::Raylib < Barista::Task
  include_behavior Omnibus

  nametag "raylib"

  dependency SDL2

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))
    env["DESTDIR"] = "#{smart_install_dir}/embedded"

    command("ls", env: env)
    command(build_command, env: env, chdir: "#{source_dir}/src")
    command(install_command, env: env, chdir: "#{source_dir}/src")
  end

  def build_command
    String.build do |io|
      io << "make"
      io << " PLATFORM=PLATFORM_DESKTOP_SDL"
      io << " GRAPHICS=GRAPHICS_API_OPENGL_ES2"
      io << " RAYLIB_LIBTYPE=SHARED"
      io << " C_INCLUDE_PATH=#{install_dir}/embedded/include/SDL2:$C_INCLUDE_PATH"
    end
  end

  def install_command
    String.build do |io|
      io << "make"
      io << " PREFIX=#{smart_install_dir}/embedded"
      io << " install RAYLIB_LIBTYPE=SHARED"
    end
  end

  def configure : Nil
    version("5.5")
    license("zlib")
    license_file("LICENSE")
    source("https://github.com/raysan5/raylib/archive/refs/tags/#{version}.tar.gz")
  end
end
