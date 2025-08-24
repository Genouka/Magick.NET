// Copyright Dirk Lemstra https://github.com/dlemstra/Magick.NET.
// Licensed under the Apache License, Version 2.0.

namespace ImageMagick;

internal static class NativeLibrary
{
    public static string Name = "Magick.Native";

    public static string QuantumName = Quantum + OpenMP;

    public static string X86Name = Name + "-" + QuantumName + "-x86.dll";

    public static string X64Name = Name + "-" + QuantumName + "-x64.dll";

    public static string Arm64Name = Name + "-" + QuantumName + "-arm64.dll";

#if Q8
    public static string Quantum = "Q8";
#elif Q16
    public static string Quantum = "Q16";
#elif Q16HDRI
    public static string Quantum = "Q16-HDRI";
#else
#error Not implemented!
#endif

#if OPENMP
    public static string OpenMP = "-OpenMP";
#else
    public static string OpenMP = "";
#endif
}
