_: final: prev:

let
  # meitner: RTX 30xx, nvidia-smi --query-gpu=name,compute_cap --format=csv
  cuda = import final.path {
    inherit (final.stdenv.hostPlatform) system;
    config = final.config // {
      cudaSupport = true;
      rocmSupport = false;
      cudaForwardCompat = false;
      cudaCapabilities = [
        "8.6"
        "12.0"
      ];
    };
  };
in
{
  ollama-cuda = prev.ollama-cuda.override {
    cudaArches = [
      "sm_86"
      "sm_120"
    ];
  };
  blender-cuda = cuda.blender;
  obs-studio-cuda = cuda.obs-studio;
  # cuda-nvcc and libnpp are unfree, ffmpeg-full only enables them with withUnfree;
  # cuda-llvm would pass --nvcc=clang and break the nvcc check
  ffmpeg-full-cuda = cuda.ffmpeg-full.override {
    withUnfree = true;
    withCudaLLVM = false;
  };
}
