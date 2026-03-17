{ ... }:
final: prev: {
  linuxKernel = prev.linuxKernel // {
    packages = prev.linuxKernel.packages // {
      linux_6_19 = prev.linuxKernel.packages.linux_6_19 // {
        virtualbox = prev.linuxKernel.packages.linux_6_19.virtualbox.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or [])
            ++ [
              (final.fetchpatch {
                url = "https://raw.githubusercontent.com/rpmfusion/VirtualBox-kmod/ec4795b376212b9361c2554c249886c62008c3f8/kernel-6.19.patch";
                sha256 = "sha256-HhJ/2dnJQIXGv86Avlb42+gRzAgNx3eq81gfDwmqjeU=";
                excludes = [
                  "vboxsf/**/*"
                  "vboxguest/**/*"
                ];
              })
            ];
        });
      };
    };
  };
}
