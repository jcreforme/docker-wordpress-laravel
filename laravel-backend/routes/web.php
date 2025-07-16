<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return response()->json([
        'message' => 'Laravel Backend API',
        'version' => '1.0.0',
        'status' => 'running',
        'endpoints' => [
            'api' => '/api',
            'health' => '/api/health',
            'wordpress' => '/api/wordpress'
        ]
    ]);
});
