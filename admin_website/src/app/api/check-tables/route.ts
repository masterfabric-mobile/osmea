import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@supabase/supabase-js';

export async function POST(request: NextRequest) {
  try {
    const { url, anonKey } = await request.json();

    if (!url || !anonKey) {
      return NextResponse.json(
        { error: 'Supabase URL and Anon Key are required' },
        { status: 400 }
      );
    }

    const supabase = createClient(url, anonKey);

    // List of tables to check
    const requiredTables = [
      'stores',
      'admin_users',
      'app_configurations',
      'builds',
    ];

    // Check each table existence using PostgreSQL query
    const tableChecks: Record<string, boolean> = {};
    const tableDetails: Record<string, { exists: boolean; rowCount?: number }> = {};

    for (const tableName of requiredTables) {
      try {
        // Try to query the table - if it exists, this will succeed
        const { data, error } = await supabase
          .from(tableName)
          .select('id')
          .limit(1);

        if (error) {
          // Check if error is "relation does not exist"
          if (error.message.includes('does not exist') || error.code === '42P01') {
            tableChecks[tableName] = false;
            tableDetails[tableName] = { exists: false };
          } else {
            // Table exists but might have other issues
            tableChecks[tableName] = true;
            tableDetails[tableName] = { exists: true };
          }
        } else {
          // Table exists and is accessible
          tableChecks[tableName] = true;
          // Try to get row count
          const { count } = await supabase
            .from(tableName)
            .select('*', { count: 'exact', head: true });
          tableDetails[tableName] = { exists: true, rowCount: count || 0 };
        }
      } catch (err) {
        tableChecks[tableName] = false;
        tableDetails[tableName] = { exists: false };
      }
    }

    const allTablesExist = Object.values(tableChecks).every(exists => exists);
    const missingTables = requiredTables.filter(table => !tableChecks[table]);

    return NextResponse.json({
      success: allTablesExist,
      allTablesExist,
      tables: tableDetails,
      missingTables,
      message: allTablesExist
        ? 'All required tables are set up correctly!'
        : `Missing tables: ${missingTables.join(', ')}`,
    });
  } catch (error) {
    console.error('Error checking tables:', error);
    return NextResponse.json(
      {
        error: 'Failed to check tables',
        message: error instanceof Error ? error.message : 'Unknown error',
      },
      { status: 500 }
    );
  }
}
