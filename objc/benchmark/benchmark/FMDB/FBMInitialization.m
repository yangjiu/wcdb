/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FBMInitialization.h"

@implementation FBMInitialization {
    FMDatabase *_database;
}

+ (NSString *)benchmarkType
{
    return [WCTBenchmarkTypeInitialization copy];
}

- (void)prepare
{
    FMDatabase *database = [[FMDatabase alloc] initWithPath:_path];
    [self openDatabase:database];
    {
        for (int i = 0; i < _config.tableCount; ++i) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@(key INTEGER,value BLOB);", [NSString stringWithFormat:@"%@%d", _tableName, i]];
            if (![database executeUpdate:sql]) {
                abort();
            }
        }
    }
    if (![database close]) {
        abort();
    }
}

- (void)preBenchmark
{
    _database = [[FMDatabase alloc] initWithPath:_path];
}

- (NSUInteger)benchmark
{
    [self openDatabase:_database];
    return _config.tableCount;
}

@end
