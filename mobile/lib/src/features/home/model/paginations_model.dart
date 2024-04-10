class SavingsHistoryPaginationModel {
  SavingsHistoryPaginationModel({
    this.totalPages = 100,
    this.currentPage = 1,
    this.hasPrevPage = false,
    this.hasNextPage = false,
  });
  int totalPages;
  bool hasPrevPage;
  bool hasNextPage;
  int currentPage;
}
