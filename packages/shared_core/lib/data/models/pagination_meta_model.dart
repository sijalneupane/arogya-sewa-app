import 'package:shared_core/domain/entities/pagination_meta_entity.dart';

class PaginationMetaModel extends PaginationMetaEntity {


  PaginationMetaModel({
    required super.totalPage,
    required super.currentPage,
    required super.pageSize,
    required super.totalRecords,
  });

  factory PaginationMetaModel.fromJson(Map<String, dynamic> json) => PaginationMetaModel(
        totalPage: json['totalPage'] as int,
        currentPage: json['currentPage'] as int,
        pageSize: json['pageSize'] as int,
        totalRecords: json['totalRecords'] as int,
      );

} 