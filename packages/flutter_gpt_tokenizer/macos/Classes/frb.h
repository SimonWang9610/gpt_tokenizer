#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
typedef struct _Dart_Handle* Dart_Handle;

typedef struct DartCObject DartCObject;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct wire_EncoderMapEntry {
  struct wire_uint_8_list *key;
  uintptr_t value;
} wire_EncoderMapEntry;

typedef struct wire_list_encoder_map_entry {
  struct wire_EncoderMapEntry *ptr;
  int32_t len;
} wire_list_encoder_map_entry;

typedef struct wire_SpecialEncoderMapEntry {
  struct wire_uint_8_list *key;
  uintptr_t value;
} wire_SpecialEncoderMapEntry;

typedef struct wire_list_special_encoder_map_entry {
  struct wire_SpecialEncoderMapEntry *ptr;
  int32_t len;
} wire_list_special_encoder_map_entry;

typedef struct wire_ArcCoreBpe {
  const void *ptr;
} wire_ArcCoreBpe;

typedef struct wire_BPEWrapper {
  struct wire_ArcCoreBpe bpe;
} wire_BPEWrapper;

typedef struct wire_StringList {
  struct wire_uint_8_list **ptr;
  int32_t len;
} wire_StringList;

typedef struct wire_uint_32_list {
  uint32_t *ptr;
  int32_t len;
} wire_uint_32_list;

typedef struct DartCObject *WireSyncReturn;

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

void wire_create_static__static_method__BPEWrapper(int64_t port_,
                                                   struct wire_list_encoder_map_entry *encoder_entries,
                                                   struct wire_list_special_encoder_map_entry *special_tokens_encoder_entries,
                                                   struct wire_uint_8_list *pattern);

void wire_encode_ordinary__method__BPEWrapper(int64_t port_,
                                              struct wire_BPEWrapper *that,
                                              struct wire_uint_8_list *text);

void wire_encode__method__BPEWrapper(int64_t port_,
                                     struct wire_BPEWrapper *that,
                                     struct wire_uint_8_list *text,
                                     struct wire_StringList *allowed_special_entries);

void wire_count_token__method__BPEWrapper(int64_t port_,
                                          struct wire_BPEWrapper *that,
                                          struct wire_uint_8_list *text,
                                          struct wire_StringList *allowed_special_entries);

void wire_encode_bytes__method__BPEWrapper(int64_t port_,
                                           struct wire_BPEWrapper *that,
                                           struct wire_uint_8_list *bytes);

void wire_encode_single_token__method__BPEWrapper(int64_t port_,
                                                  struct wire_BPEWrapper *that,
                                                  struct wire_uint_8_list *piece);

void wire_encode_single_piece__method__BPEWrapper(int64_t port_,
                                                  struct wire_BPEWrapper *that,
                                                  struct wire_uint_8_list *piece);

void wire_decode_bytes__method__BPEWrapper(int64_t port_,
                                           struct wire_BPEWrapper *that,
                                           struct wire_uint_32_list *tokens);

void wire_decode_single_token_bytes__method__BPEWrapper(int64_t port_,
                                                        struct wire_BPEWrapper *that,
                                                        uintptr_t token);

struct wire_ArcCoreBpe new_ArcCoreBpe(void);

struct wire_StringList *new_StringList_0(int32_t len);

struct wire_BPEWrapper *new_box_autoadd_bpe_wrapper_0(void);

struct wire_list_encoder_map_entry *new_list_encoder_map_entry_0(int32_t len);

struct wire_list_special_encoder_map_entry *new_list_special_encoder_map_entry_0(int32_t len);

struct wire_uint_32_list *new_uint_32_list_0(int32_t len);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

void drop_opaque_ArcCoreBpe(const void *ptr);

const void *share_opaque_ArcCoreBpe(const void *ptr);

void free_WireSyncReturn(WireSyncReturn ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_create_static__static_method__BPEWrapper);
    dummy_var ^= ((int64_t) (void*) wire_encode_ordinary__method__BPEWrapper);
    dummy_var ^= ((int64_t) (void*) wire_encode__method__BPEWrapper);
    dummy_var ^= ((int64_t) (void*) wire_count_token__method__BPEWrapper);
    dummy_var ^= ((int64_t) (void*) wire_encode_bytes__method__BPEWrapper);
    dummy_var ^= ((int64_t) (void*) wire_encode_single_token__method__BPEWrapper);
    dummy_var ^= ((int64_t) (void*) wire_encode_single_piece__method__BPEWrapper);
    dummy_var ^= ((int64_t) (void*) wire_decode_bytes__method__BPEWrapper);
    dummy_var ^= ((int64_t) (void*) wire_decode_single_token_bytes__method__BPEWrapper);
    dummy_var ^= ((int64_t) (void*) new_ArcCoreBpe);
    dummy_var ^= ((int64_t) (void*) new_StringList_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_bpe_wrapper_0);
    dummy_var ^= ((int64_t) (void*) new_list_encoder_map_entry_0);
    dummy_var ^= ((int64_t) (void*) new_list_special_encoder_map_entry_0);
    dummy_var ^= ((int64_t) (void*) new_uint_32_list_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) drop_opaque_ArcCoreBpe);
    dummy_var ^= ((int64_t) (void*) share_opaque_ArcCoreBpe);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}
