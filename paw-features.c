#include "paw-features.h"
#include "version.h"

const char version_and_features[] =
    "version: " PAW_VERSION

#if defined(PAW_PGO_ENABLED) && PAW_PGO_ENABLED
    " +pgo"
#else
    " -pgo"
#endif

#if defined(PAW_IME_ENABLED) && PAW_IME_ENABLED
    " +ime"
#else
    " -ime"
#endif

#if defined(PAW_GRAPHEME_CLUSTERING) && PAW_GRAPHEME_CLUSTERING
    " +graphemes"
#else
    " -graphemes"
#endif

#if defined(HAVE_XDG_TOPLEVEL_TAG)
    " +toplevel-tag"
#else
    " -toplevel-tag"
#endif

#if defined(HAVE_EXT_BACKGROUND_EFFECT)
    " +blur"
#else
    " -blur"
#endif

#if !defined(NDEBUG)
    " +assertions"
#else
    " -assertions"
#endif
;
