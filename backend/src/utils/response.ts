// ─────────────────────────────────────────────
// Standardized API Response Helpers
// ─────────────────────────────────────────────

export interface ApiResponse<T = unknown> {
  success: boolean;
  message: string;
  data?: T;
  meta?: ApiMeta;
  errors?: ApiError[];
  timestamp: string;
}

export interface ApiMeta {
  page?: number;
  limit?: number;
  total?: number;
  totalPages?: number;
}

export interface ApiError {
  field?: string;
  message: string;
  code?: string;
}

export function successResponse<T>(
  message: string,
  data?: T,
  meta?: ApiMeta,
): ApiResponse<T> {
  return {
    success: true,
    message,
    data,
    meta,
    timestamp: new Date().toISOString(),
  };
}

export function errorResponse(
  message: string,
  errors?: ApiError[],
): ApiResponse {
  return {
    success: false,
    message,
    errors,
    timestamp: new Date().toISOString(),
  };
}

// ─────────────────────────────────────────────
// Pagination Helper
// ─────────────────────────────────────────────
export interface PaginationParams {
  page: number;
  limit: number;
}

export function getPaginationMeta(
  total: number,
  params: PaginationParams,
): ApiMeta {
  return {
    page: params.page,
    limit: params.limit,
    total,
    totalPages: Math.ceil(total / params.limit),
  };
}

export function getPaginationSkip(params: PaginationParams): number {
  return (params.page - 1) * params.limit;
}
