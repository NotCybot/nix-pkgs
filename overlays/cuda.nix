_: final: prev:

let
  # meitner: RTX 30xx, nvidia-smi --query-gpu=name,compute_cap --format=csv
  cuda = final.pkgsForCudaArch.sm_86;
in
{
  ollama-cuda = prev.ollama-cuda.override { cudaArches = [ "sm_86" ]; };
  blender-cuda = cuda.blender;
  obs-studio-cuda = cuda.obs-studio;
  # cuda-nvcc and libnpp are unfree, ffmpeg-full only enables them with withUnfree
  ffmpeg-full-cuda = cuda.ffmpeg-full.override { withUnfree = true; };
}
