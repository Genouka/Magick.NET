// Copyright Dirk Lemstra https://github.com/dlemstra/Magick.NET.
// Licensed under the Apache License, Version 2.0.

namespace ImageMagick;

internal static class NativeLibrary
{
    public string Name = "Magick.Native";

    public string QuantumName = Quantum + OpenMP;

    public string X86Name = Name + "-" + QuantumName + "-x86.dll";

    public string X64Name = Name + "-" + QuantumName + "-x64.dll";

    public string Arm64Name = Name + "-" + QuantumName + "-arm64.dll";

#if Q8
    public string Quantum = "Q8";
#elif Q16
    public string Quantum = "Q16";
#elif Q16HDRI
    public string Quantum = "Q16-HDRI";
#else
#error Not implemented!
#endif

#if OPENMP
    public string OpenMP = "-OpenMP";
#else
    public string OpenMP = "";
#endif
}
