#include <csv.h>
#include <stdlib.h>

struct csv_parser *
csv_new(unsigned char options)
{
  struct csv_parser *self;
  self = malloc(sizeof(struct csv_parser));
  csv_init(self, options);
  return self;
}

void
csv_DESTROY(struct csv_parser *self)
{
  csv_free(self);
  free(self);
}
