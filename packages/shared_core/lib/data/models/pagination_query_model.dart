import '../../domain/entities/pagination_query_entity.dart';

class PaginationQueryModel extends PaginationQueryEntity {
  PaginationQueryModel({
    super.page,
    super.size,
  });

  Map<String, dynamic> toJson() {
    return {
      if (page != null) 'page': page,
      if (size != null) 'size': size,
    };
  }

  factory PaginationQueryModel.fromEntity(PaginationQueryEntity entity) {
    return PaginationQueryModel(
      page: entity.page,
      size: entity.size,
    );
  }
}
