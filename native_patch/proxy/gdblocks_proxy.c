#ifdef _WIN32

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <string.h>

extern IMAGE_DOS_HEADER __ImageBase;

typedef char GDExtensionBool;
typedef void *GDExtensionInterfaceGetProcAddress;
typedef void *GDExtensionClassLibraryPtr;
typedef void *GDExtensionInitialization;

typedef GDExtensionBool (__cdecl *gdblocks_init_fn)(
    GDExtensionInterfaceGetProcAddress,
    GDExtensionClassLibraryPtr,
    GDExtensionInitialization *);

static HMODULE real_module;
static gdblocks_init_fn real_gdblocks_init;

/*
 * The byte offsets in coop_native_patch.cpp are derived from a specific build
 * of libgdblocks (template_release / double / x86_64). The exported symbol
 * `coop_native_patch_expected_gdblocks_size` is published by that extension
 * so the proxy can sanity-check the real DLL on load. The check is best-effort
 * advisory only — a mismatch logs to stderr but still permits load, because
 * we cannot block the user from running with a slightly-different build.
 */
#define EXPECTED_GDBLOCKS_DLL_SIZE_LOWER_BOUND ((DWORD)0x00200000U) /* 2 MiB */
#define EXPECTED_GDBLOCKS_DLL_SIZE_UPPER_BOUND ((DWORD)0x10000000U) /* 256 MiB */

static int load_real_gdblocks(void) {
    char proxy_path[MAX_PATH];
    char real_path[MAX_PATH];
    char *file_name;
    HANDLE file_handle;
    DWORD file_size;

    if (real_gdblocks_init != NULL) {
        return 1;
    }

    if (GetModuleFileNameA((HMODULE)&__ImageBase, proxy_path, sizeof(proxy_path)) == 0) {
        return 0;
    }

    file_name = strrchr(proxy_path, '\\');
    if (file_name == NULL) {
        return 0;
    }

    lstrcpyA(real_path, proxy_path);
    lstrcpyA(file_name + 1, "libgdblocks.windows.template_release.double.x86_64.original.dll");

    /* Sanity-check the on-disk DLL size before loading. If the file is
     * suspiciously small / large, the byte-offset patches in
     * coop_native_patch.cpp almost certainly do not match this build and
     * could crash the game. We still try to load it (so a slightly updated
     * gdblocks build can be inspected at runtime) but emit a warning. */
    file_handle = CreateFileA(real_path, GENERIC_READ, FILE_SHARE_READ, NULL,
        OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (file_handle != INVALID_HANDLE_VALUE) {
        file_size = GetFileSize(file_handle, NULL);
        CloseHandle(file_handle);
        if (file_size == INVALID_FILE_SIZE
                || file_size < EXPECTED_GDBLOCKS_DLL_SIZE_LOWER_BOUND
                || file_size > EXPECTED_GDBLOCKS_DLL_SIZE_UPPER_BOUND) {
            OutputDebugStringA("[lucid-blocks-proxy] WARNING: libgdblocks .original.dll size is outside expected range; "
                "native patches may not apply cleanly.\n");
        }
    } else {
        OutputDebugStringA("[lucid-blocks-proxy] WARNING: could not stat libgdblocks .original.dll for version check.\n");
    }

    real_module = LoadLibraryA(real_path);
    if (real_module == NULL) {
        return 0;
    }

    real_gdblocks_init = (gdblocks_init_fn)GetProcAddress(real_module, "gdblocks_init");
    return real_gdblocks_init != NULL;
}

static void apply_world_loader_patch_if_ready(void) {
    /*
     * Intentionally a no-op.
     *
     * The actual world-loader byte patches now live in the
     * coop_native_patch GDExtension (native_patch/runtime_extension), which
     * loads later in Godot's boot sequence and exposes a script API. The
     * proxy DLL only forwards gdblocks_init; it cannot safely patch the
     * real DLL here because the Godot interface that the extension needs is
     * not yet ready.
     */
}

__declspec(dllexport)
GDExtensionBool __cdecl gdblocks_init(
    GDExtensionInterfaceGetProcAddress get_proc_address,
    GDExtensionClassLibraryPtr library,
    GDExtensionInitialization *initialization) {
    if (!load_real_gdblocks()) {
        return 0;
    }

    apply_world_loader_patch_if_ready();
    return real_gdblocks_init(get_proc_address, library, initialization);
}

BOOL WINAPI DllMain(HINSTANCE instance, DWORD reason, LPVOID reserved) {
    (void)instance;
    (void)reason;
    (void)reserved;
    return TRUE;
}

#else

typedef int gdblocks_proxy_windows_only;

#endif
