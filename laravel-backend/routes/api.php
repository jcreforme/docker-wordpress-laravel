<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// WordPress Integration Routes
Route::prefix('wordpress')->group(function () {
    Route::get('/posts', function () {
        // Example endpoint to fetch WordPress posts
        return response()->json([
            'message' => 'WordPress posts endpoint',
            'status' => 'ready'
        ]);
    });
    
    Route::get('/categories', function () {
        // Example endpoint to fetch WordPress categories
        return response()->json([
            'message' => 'WordPress categories endpoint',
            'status' => 'ready'
        ]);
    });
});

// Health check endpoint
Route::get('/health', function () {
    return response()->json([
        'status' => 'ok',
        'timestamp' => now(),
        'service' => 'Laravel Backend API'
    ]);
});
