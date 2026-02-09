class PaginationMetaEntity {
  final int totalPage;
  final int currentPage;
  final int pageSize;
  final int totalRecords;

  PaginationMetaEntity({
    required this.totalPage,
    required this.currentPage,
    required this.pageSize,
    required this.totalRecords,
  });
}