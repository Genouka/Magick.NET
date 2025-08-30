// Copyright Dirk Lemstra https://github.com/dlemstra/Magick.NET.
// Licensed under the Apache License, Version 2.0.

namespace ImageMagick;

internal static class NativeLibrary
{
    public const string Name = "libMagick.Native";

    public const string QuantumName = Quantum + OpenMP;

    public const string X86Name = Name + "-" + QuantumName + "-x86.dll";

    public const string X64Name = Name + "-" + QuantumName + "-x64.dll";

    public const string Arm64Name = Name + "-" + QuantumName + "-arm64.dll.so";

#if Q8
    public const string Quantum = "Q8";
#elif Q16
    public const string Quantum = "Q16";
#elif Q16HDRI
    public const string Quantum = "Q16-HDRI";
#else
#error Not implemented!
#endif

#if OPENMP
    public const string OpenMP = "-OpenMP";
#else
    public const string OpenMP = "";
#endif
}
