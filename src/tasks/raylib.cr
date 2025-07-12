@[Barista::BelongsTo(Hokusai::OS::Builder)]
class Hokusai::OS::Tasks::Raylib < Barista::Task
  include_behavior Omnibus

  nametag "raylib"

  def build : Nil
  end

  def configure : Nil
  end
end
